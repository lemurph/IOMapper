#!/usr/bin/python3

import cv2
import mediapipe as mp
import mapper as mpr
mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands


hand_dev = mpr.device("hand_tracker")

one_y = hand_dev.add_signal(mpr.DIR_OUT, "one_y", 1,
                              mpr.FLT, None, None, None)
two_y = hand_dev.add_signal(mpr.DIR_OUT, "two_y", 1,
                              mpr.FLT, None, None, None)

# Begin webcam input for hand tracking:
hands = mp_hands.Hands(min_detection_confidence=0.7,
                       min_tracking_confidence=0.5)

cap = cv2.VideoCapture(0)

width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)

print(width, height)

while(not hand_dev.get_is_ready()):
    hand_dev.poll(25)

print("Libmapper Dev Ready!")

while cap.isOpened():
    success, image = cap.read()
    if not success:
        break

    # Poll the mediapipe devices to ensure that the signals are being updated properly
    hand_dev.poll()

    # Flip the image horizontally for a later selfie-view display, and convert
    # the BGR image to RGB.
    image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)

    # To improve performance, optionally mark the image as not writeable to
    # pass by reference.
    #image.flags.writeable = False
    results = hands.process(image)

    # Draw the hand annotations on the image.
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    if results.multi_hand_landmarks:
        if (len(results.multi_hand_landmarks) == 2):
            for hand in results.multi_hand_landmarks:
    
                if (results.multi_handedness[results.multi_hand_landmarks.index(hand)].classification[0].label == "Left"):
                    one_y.set_value(hand.landmark[8].y)
                    mp_drawing.draw_landmarks(
                    image, hand, mp_hands.HAND_CONNECTIONS,
                    mp_drawing.DrawingSpec(color=(92, 49, 29), thickness=2, circle_radius=4),
                    mp_drawing.DrawingSpec(color=(201, 107, 62), thickness=2, circle_radius=2))
                else:
                    two_y.set_value(hand.landmark[8].y)
                    mp_drawing.draw_landmarks(
                    image, hand, mp_hands.HAND_CONNECTIONS,
                    mp_drawing.DrawingSpec(color=(105, 39, 94), thickness=2, circle_radius=4),
                    mp_drawing.DrawingSpec(color=(217, 54, 190), thickness=2, circle_radius=2))
                

                
    cv2.imshow('MediaPipe Hands', image)

    if cv2.waitKey(5) & 0xFF == 27:
        break

hands.close()
cap.release()
