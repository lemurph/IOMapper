./umapper -M hand_tracker.1/one_index hand_tracker.1/one_thumb pong.1/player1_y @expr "pinch=(x0-x1).norm();y=(pinch<=0.1)?(x0[1]+x1[1])/2:y{-1};"
./umapper -M hand_tracker.1/two_index hand_tracker.1/two_thumb pong.1/player2_y @expr "pinch=(x0-x1).norm();y=(pinch<=0.1)?(x0[1]+x1[1])/2:y{-1};"
