FROM node:14.21.3 AS builder
WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY .eslintrc.js .prettierignore .prettierrc .rescriptsrc.js LICENSE netlify.toml tsconfig.json ./
COPY public ./public
COPY src ./src
COPY .env.cytonic.testnet ./.env
RUN yarn build

FROM nginx:1.27.2-alpine
COPY --from=builder /app/build /usr/share/nginx/html
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]