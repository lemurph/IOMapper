#!/usr/bin/python3

import cv2
import mediapipe as mp
import mapper as mpr
import math

mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands


hand_dev = mpr.device("hand_tracker")

amplitude_dist = hand_dev.add_signal(mpr.DIR_OUT, "middle-palm-distance", 1,
                           mpr.FLT, None, None, None)
steepness_dist = hand_dev.add_signal(mpr.DIR_OUT, "thumb-index-distance", 1,
                            mpr.FLT, None, None, None)
wind_align_dist = hand_dev.add_signal(mpr.DIR_OUT, "thumb-pinky-distance", 1,
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
    image.flags.writeable = False
    results = hands.process(image)

    # Draw the hand annotations on the image.
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    if results.multi_hand_landmarks:
        # Update the libmapper devices with landmark data
        for hand_landmarks in results.multi_hand_landmarks:

            # Compute distance between middle-finger-tip and bottom of palm
            middle_palm_distance = abs(math.hypot(
                hand_landmarks.landmark[12].x - hand_landmarks.landmark[0].x, hand_landmarks.landmark[12].y - hand_landmarks.landmark[0].y))

            # Compute distance between thumb tip and middle-finger-tip
            thumb_index_distance = abs(math.hypot(
                hand_landmarks.landmark[8].x - hand_landmarks.landmark[4].x, hand_landmarks.landmark[8].y - hand_landmarks.landmark[4].y))

            # Compute distance between thumb tip and pinky tip
            thumb_pinky_distance = abs(math.hypot(
                hand_landmarks.landmark[20].x - hand_landmarks.landmark[4].x, hand_landmarks.landmark[20].y - hand_landmarks.landmark[4].y))

            # Update signal with value calculated above
            amplitude_dist.set_value(middle_palm_distance)
            steepness_dist.set_value(thumb_index_distance)
            wind_align_dist.set_value(thumb_pinky_distance)


            # Draw skeletal structure over video
            mp_drawing.draw_landmarks(
                image, hand_landmarks, mp_hands.HAND_CONNECTIONS)

    cv2.imshow('MediaPipe Hands', image)

    if cv2.waitKey(5) & 0xFF == 27:
        break

hands.close()
cap.release()
