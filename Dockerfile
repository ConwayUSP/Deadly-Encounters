FROM node:10 as build

WORKDIR /app/src
COPY assets ./assets/
COPY modules ./modules/
COPY sounds ./sounds/
COPY main.lua conf.lua ./

RUN npm install -g love.js
RUN love.js /app/src /app/dist --title "Deadly Encounter" --memory 67108864

FROM nginx:1.17.0-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf