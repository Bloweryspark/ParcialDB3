const express = require('express');
const path = require('path');
const SqlConnection = require('./sql/connection.js');

const app = express();
const port = 3000;


// Middleware básico
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname)));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// SUBIR PLAYER ALEATORIO A SQL//

const nombres1 = ['Shadow','Fire','Ghost','Ninja','Cyber','Dark','Neo','Red','Crazy','Epic'];
const nombres2 = ['Hunter','Master','Rider','Sniper','Killer','Storm','Wolf','Blade','Boss','Dragon'];

function generarNombreGamer() {
  const p1 = nombres1[Math.floor(Math.random()*nombres1.length)];
  const p2 = nombres2[Math.floor(Math.random()*nombres2.length)];
  const num = Math.floor(Math.random()*1000);
  return `${p1}${p2}${num}`;
}

function generarJugador() {
  const User = generarNombreGamer();
  const PlayedTime = `${Math.floor(Math.random()*200)}h ${Math.floor(Math.random()*60)}m`;
  const FireFrecuency = `${Math.floor(Math.random()*100)} disparos/min`;
  const DeadCount = Math.floor(Math.random()*50);
  const KillCount = Math.floor(Math.random()*50);
  const KillRatio = DeadCount>0 ? (KillCount/DeadCount).toFixed(2) : KillCount;
  const Money = `$${Math.floor(Math.random()*10000)}`;
  return { User, PlayedTime, FireFrecuency, DeadCount, KillCount, KillRatio, Money };
}

app.post('/insertar-jugador', async (req, res) => {
  const db = new SqlConnection();
  try {
    await db.connectToDb();
    const [{ maxId }] = await db.query("SELECT MAX(idPlayers) AS maxId FROM Players");
    const nextId = (maxId || 0) + 1;
    const j = generarJugador();
    const sql = `
      INSERT INTO Players 
        (idPlayers, User, PlayedTime, FireFrecuency, DeadCount, KillCount, KillRatio, Money)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    await db.query(sql, [
      nextId,
      j.User,
      j.PlayedTime,
      j.FireFrecuency,
      j.DeadCount,
      j.KillCount,
      j.KillRatio,
      j.Money
    ]);
    res.send(`Jugador ${j.User} insertado con ID ${nextId}`);
  } catch (err) {
    console.error("Error al insertar jugador:", err);
    res.status(500).send("Error al insertar jugador.");
  } finally {
    await db.closeConnection();
  }
});

function generarLobby() {
  const nombresLobby = ['Los Santos', 'Vinewood', 'Downtown', 'Blaine County', 'Sandy Shores'];
  const estadosLobby = ['Activo', 'Inactivo', 'En espera'];
  const locs = ['Ciudad', 'Montaña', 'Playa', 'Desierto'];

  const idLobby = Math.floor(Math.random() * 10000);
  const name = `Lobby_${idLobby}`;
  const ActivePlayers = Math.floor(Math.random() * 10) + 1; // entre 1 y 10 jugadores activos
  const ActiveTime = `${Math.floor(Math.random() * 120)} mins`; // tiempo activo random
  const Location = locs[Math.floor(Math.random() * locs.length)];

  return {
    idLobby,
    name,
    ActivePlayers: ActivePlayers.toString(),
    ActiveTime,
    Location,
  };
}

app.post('/crearlobby', async (req, res) => {
  try {
    const lobby = generarLobby();

    const sql = `INSERT INTO Lobby (idLobby, name, ActivePlayers, ActiveTime, Location) VALUES (?, ?, ?, ?, ?) `;

    const db = new SqlConnection();
    await db.connectToDb();
    await db.query(sql, [
      lobby.idLobby,
      lobby.name,
      lobby.ActivePlayers,
      lobby.ActiveTime,
      lobby.Location,
    ]);
    await db.closeConnection();

    res.status(200).send(`Lobby creado: ${lobby.name}`);
  } catch (err) {
    console.error('Error al crear lobby:', err);
    res.status(500).send('Error al crear lobby');
  }
});




app.get('/traer-datos', async (req, res) => {
  try {
    const db = new SqlConnection();
    await db.connectToDb();
    console.log('si sirve');
    const jugadores = await db.query('SELECT idPlayers, User FROM Players');
    const lobbies = await db.query('SELECT * FROM Lobby');

    await db.closeConnection();

    res.json({ jugadores, lobbies });
  } catch (err) {
    console.error('Error al traer datos:', err);
    res.status(500).send('Error al traer datos');
  }
});

app.post('/reportar', async (req, res) => {
  try {
    const { reporter, reported, reason } = req.body;

    const db = new SqlConnection();
    await db.connectToDb();

    // Para el idReports, si no tienes autoincrement, genera uno aleatorio (ideal cambiar la tabla para auto_increment)
    const idReports = Math.floor(Math.random() * 10000);

    const sql = `
      INSERT INTO Reports (idReports, Reporter, Reported, Reason)
      VALUES (?, ?, ?, ?)
    `;

    await db.query(sql, [idReports, reporter, reported, reason]);
    await db.closeConnection();

    res.send('Reporte enviado con éxito');
  } catch (err) {
    console.error('Error al insertar reporte:', err);
    res.status(500).send('Error al enviar reporte');
  }
});

app.get('/traer-reportes', async (req, res) => {
  try {
    const db = new SqlConnection();
    await db.connectToDb();
    const reportes = await db.query('SELECT Reporter, Reported, Reason FROM Reports');
    await db.closeConnection();
    res.json({ reportes });
  } catch (err) {
    console.error('Error al traer reportes:', err);
    res.status(500).send('Error al traer reportes');
  }
});

app.listen(port, () => {
  console.log(`Servidor funcionando en http://localhost:${port}`);
});
