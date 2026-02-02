import express, { Express, Request, Response } from 'express';
const app: Express = express();
const PORT: number = parseInt(process.env.PORT || '3000');

app.use(express.json());

// Route GET /
app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Hello from TypeScript + Node.js on Alpine!' });
});

// Route GET /health
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Route POST /echo
app.post('/echo', (req: Request, res: Response) => {
  res.json({ received: req.body });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
