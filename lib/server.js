import express from 'express';
import { apiController } from './controller/api';
import { spaController } from './controller/spa';

const PORT = process.env.PORT || 3000;
const app = express();

var compression = require('compression');

app.use(express.static('dist'));
app.use(apiController);
app.use(spaController);
app.use(compression());

app.listen(PORT);
