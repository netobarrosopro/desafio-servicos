function updateDateTime() {
    const now = new Date();
    const formattedDate = now.toLocaleString('pt-BR', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('datetime').textContent = `Data e Hora Atual: ${formattedDate}`;
}

// Atualiza automaticamente ao carregar a página
window.onload = updateDateTime;