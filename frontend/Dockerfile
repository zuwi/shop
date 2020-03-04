FROM node:12.2.0-alpine

# Set the working directory where the commands will be executed
RUN mkdir /frontend
WORKDIR /frontend

# Copy the frontend in the current directory
COPY . ./

# Add Node modules to $PATH
ENV PATH /frontend/node_modules/.bin:$PATH

# Install and cache app dependencies
RUN npm install
ENTRYPOINT ["npm", "run", "start"]

# Expose port 8080 to the Docker host, so we can access it from the outside
# EXPOSE 8080

# The main command to run when the container starts
# CMD ["yarn", "dev"]
