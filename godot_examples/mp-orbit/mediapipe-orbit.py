#!/usr/bin/python3

import cv2
import mediapipe as mp
import mapper as mpr
mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands


hand_dev = mpr.device("hand_tracker")

index_x = hand_dev.add_signal(mpr.DIR_OUT, "index_x", 1,
                              mpr.INT32, None, None, None)
index_y = hand_dev.add_signal(mpr.DIR_OUT, "index_y", 1,
                              mpr.INT32, None, None, None)

# Begin webcam input for hand tracking:
hands = mp_hands.Hands(min_detection_confidence=0.7,
                       min_tracking_confidence=0.5)

cap = cv2.VideoCapture(0)

width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)

print(width, height)

while cap.isOpened():
    success, image = cap.read()
    if not success:
        break

    # Poll the mediapipe devices to ensure that the signals are being updated properly
    hand_dev.poll(0)

    # Flip the image horizontally for a later selfie-view display, and convert
    # the BGR image to RGB.
    image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)

    cv2.circle(image, (320, 240), 200, (255, 0, 0), 1)

    # To improve performance, optionally mark the image as not writeable to
    # pass by reference.
    image.flags.writeable = False
    results = hands.process(image)

    # Draw the hand annotations on the image.
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    if results.multi_hand_landmarks:
        # Update the libmapper devices with landmark data
        for hand_landmarks in results.multi_hand_landmarks:

            # Update signal values
            index_x.set_value(hand_landmarks.landmark[8].x)
            index_y.set_value(hand_landmarks.landmark[8].y)

            # Draw skeletal structure over video
            mp_drawing.draw_landmarks(
                image, hand_landmarks, mp_hands.HAND_CONNECTIONS)

    cv2.imshow('MediaPipe Hands', image)

    if cv2.waitKey(5) & 0xFF == 27:
        break

hands.close()
cap.release()
