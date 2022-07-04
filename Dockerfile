FROM node:16-alpine AS dependencies

RUN apk update \
    && apk add --no-cache libc6-compat=1.2.3-r0

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

FROM node:16-alpine as builder

WORKDIR /app

COPY . .
COPY --from=dependencies /app/node_modules ./node_modules

ENV NEXT_TELEMETRY_DISABLED=1

ARG build_command=build
RUN yarn $build_command

FROM node:16-alpine as runner
WORKDIR /app

COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/app-insights.js ./app-insights.js
COPY --from=builder /app/ecosystem.config.js ./

ENV NEXT_TELEMETRY_DISABLED=1

RUN npx next telemetry disable

EXPOSE 3000
CMD ["yarn", "pm2-start"]