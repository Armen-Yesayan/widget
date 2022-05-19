FROM node:14.18-alpine As development
WORKDIR /usr/src/app

COPY package*.json ./
COPY yarn.lock ./

RUN yarn add glob rimraf

RUN yarn install --production=false

COPY . .

RUN yarn build

FROM node:14.18-alpine As production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./
COPY yarn.lock ./

RUN apk --no-cache add curl
RUN yarn install --production=false

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]

EXPOSE 3000