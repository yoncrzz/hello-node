# Step 1: Building the Node App
FROM node:18 AS build
WORKDIR /app
COPY server.js .
# There are no dependencies, but if you had a package.json: COPY package*.json . && npm install

#Stage 2: Final image with NGINX
FROM nginx:alpine
# We copy the Node.js binary from the previous stage
COPY --from=build /usr/local/bin/node /usr/local/bin/node
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /app /app

# We copy NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# We run Node in the background and NGINX in the foreground
CMD node /app/server.js & nginx -g "daemon off;"