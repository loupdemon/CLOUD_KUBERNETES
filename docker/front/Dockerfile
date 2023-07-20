# Step 1: Build the Angular app
FROM node:11 AS build

WORKDIR /app

ENV NODE_ENV prod

# Install app dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app for production
# Check if ENV is prod or dev
# RUN if [ "$NODE_ENV" = "dev" ]; then npm run build; else npm run build:prod; fi
RUN npm run build:prod
#RUN npm run build

 # Step 2: Serve the Angular app from Nginx
FROM nginx:alpine

#RUN rm /etc/nginx/conf.d/default.conf
#COPY nginx.conf /etc/nginx/conf.d
COPY --from=build /app/dist/front /usr/share/nginx/html

EXPOSE 80
