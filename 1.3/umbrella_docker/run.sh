docker run --rm -ti \
             -p 4000:4000 \
             -e COOKIE=a_cookie \
             -e BASIC_AUTH_USERNAME=username \
             -e BASIC_AUTH_PASSWORD=password \
             -e BASIC_AUTH_REALM=realm \
             paraguas:0.1.0
