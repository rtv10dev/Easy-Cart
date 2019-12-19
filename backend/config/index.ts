export default {
  servicePort: '3000',
  mongo: {
    url: 'mongodb://localhost:27017/easyCart',
    settings: {
      useFindAndModify: false,
      useNewUrlParser: true,
      useCreateIndex: true,
      useUnifiedTopology: true,
    },
  },
  firebase: {
    databaseURL: 'https://<DATABASE_NAME>.firebaseio.com',
    topic: 'products'
  },
};
