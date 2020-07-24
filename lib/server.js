import express from 'express';
import { apiController } from './controller/api';
import { spaController } from './controller/spa';

const PORT = process.env.PORT || 3000;
const app = express();

const compression = require('compression');

app.use(compression({ level: 9 }));
app.use(express.static('dist'));
app.use(apiController);
app.use(spaController);

app.listen(PORT);
