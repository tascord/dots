const faces = [':)', ':3', ':P', ':D'];

export default defineEventHandler(() => {
    return `Hello, flora ${faces[Math.floor(Math.random() * faces.length)]}`;
})