const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// Serve arquivos estáticos do frontend
app.use(express.static(path.join(__dirname, 'public')));

// API endpoint básico (funcionalidade de backend)
app.get('/api/time', (req, res) => {
  const now = new Date();
  res.json({
    currentTime: now.toLocaleString('pt-BR', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
  });
});

// Rota fallback para frontend (SPA-like, mas simples)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});