FROM python:3.7

WORKDIR /backend

COPY ./install_reqs.sh ./install_reqs.sh
COPY ./utils ./utils/
COPY ./run_service.py ./run_service.py

# RUN pip3 install -r requirements.txt
RUN ./install_reqs.sh


ENTRYPOINT [ "python3" ]

CMD [ "./run_service.py" ]



