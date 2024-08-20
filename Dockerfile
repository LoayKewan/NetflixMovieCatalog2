FROM python:3.10-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache gcc musl-dev linux-headers

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["python", "app.py"]

CMD ["py "]
