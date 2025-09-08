async function checkHealth() {
  const out = document.getElementById('health');
  out.textContent = 'Checking...';
  try {
    const res = await fetch('/api/health');
    const data = await res.json();
    out.textContent = JSON.stringify(data, null, 2);
  } catch (e) {
    out.textContent = 'Failed: ' + e;
  }
}

async function loadTodos() {
  const ul = document.getElementById('list');
  ul.innerHTML = '<li>Loading...</li>';
  try {
    const res = await fetch('/api/todos');
    const data = await res.json();
    if (!Array.isArray(data)) throw new Error('Bad response');
    ul.innerHTML = '';
    data.forEach(t => {
      const li = document.createElement('li');
      li.innerHTML = `
        <span>${t.title}</span>
        <button data-id="${t.id}">✕</button>
      `;
      ul.appendChild(li);
    });
  } catch (e) {
    ul.innerHTML = '<li>Failed to load todos</li>';
  }
}

async function addTodo(title) {
  await fetch('/api/todos', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title })
  });
  await loadTodos();
}

async function deleteTodo(id) {
  await fetch('/api/todos/' + id, { method: 'DELETE' });
  await loadTodos();
}

document.getElementById('check').addEventListener('click', checkHealth);

document.getElementById('add-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const input = document.getElementById('title');
  const title = input.value.trim();
  if (title) await addTodo(title);
  input.value = '';
});

document.getElementById('list').addEventListener('click', async (e) => {
  if (e.target.tagName === 'BUTTON') {
    const id = e.target.getAttribute('data-id');
    await deleteTodo(id);
  }
});

checkHealth();
loadTodos();