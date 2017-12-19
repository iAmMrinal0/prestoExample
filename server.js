const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const app = express()
app.use(cors())
app.use(bodyParser.json())

app.get('/time', (req, res) => {
  var date = new Date().toISOString()
  res.send(JSON.stringify(date))
})

app.post('/update', (req, res) => {
  res.send(req.body)
})

app.get('/error', (req, res) => {
  res.sendStatus(500)
})

app.listen(3000, (err) => {
  if (err) {
    console.log('Error in starting server: ', err)
  }
  else {
    console.log('Listening on PORT 3000')
  }
})
