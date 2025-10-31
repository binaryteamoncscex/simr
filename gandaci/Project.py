import cv2
import numpy as np
import requests
import time


cap = cv2.VideoCapture(0)
if not cap.isOpened():
    print("Eroare: Nu se poate accesa camera. Verifică dacă este conectată și disponibilă.")
    exit()



lower_black = np.array([0, 0, 0])
upper_black = np.array([180, 100, 100])
MIN_AREA = 500


SERVER_URL = "https://management-restaurant.eu/camera/upload.php"


while True:
    ret, frame = cap.read()
    if not ret:
        print("Eroare: Nu se poate citi frame-ul.")
        break


    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    mask = cv2.inRange(hsv, lower_black, upper_black)


    kernel = np.ones((5, 5), np.uint8)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)


    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)


    darkest_contour = None
    min_avg_v = 256

    for contour in contours:
        area = cv2.contourArea(contour)
        if area > MIN_AREA:

            x, y, w, h = cv2.boundingRect(contour)
            roi_hsv = hsv[y:y + h, x:x + w]


            roi_mask = mask[y:y + h, x:x + w]


            avg_v = cv2.mean(roi_hsv[:, :, 2], mask=roi_mask)[0]


            if avg_v < min_avg_v:
                min_avg_v = avg_v
                darkest_contour = contour

    detected_count = 0
    if darkest_contour is not None:
        x, y, w, h = cv2.boundingRect(darkest_contour)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 255), 2)
        cv2.putText(frame, f"Gandac", (x, y - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        detected_count = 1

    cv2.putText(frame, f'Detectii: {detected_count}', (10, frame.shape[0] - 10),
                cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

    _, img_encoded = cv2.imencode('.jpg', frame)

    try:
        requests.post(SERVER_URL, data=img_encoded.tobytes(),
                      headers={'Content-Type': 'image/jpeg'}, timeout=2)
    except Exception as e:
        print(f"Eroare upload la server: {e}")

    time.sleep(0.1)

cap.release()
cv2.destroyAllWindows()