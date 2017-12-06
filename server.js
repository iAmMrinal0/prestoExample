const express = require('express')
const cors = require('cors')
const app = express()
app.use(cors())
app.get('/', (req, res) =>{
  var date = new Date().toISOString()
  res.send(date)
})

app.listen(3000, (err) => {
  if (err) {
    console.log('Error in starting server: ', err)
  }
  else {
    console.log('Listening on PORT 3000')
  }
})
