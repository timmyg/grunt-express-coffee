express = require 'express'
passport = require 'passport'
mongoose = require 'mongoose'
compression = require 'compression'
morgan = require 'morgan'
# livereload = require 'express-livereload'

ASSET_BUILD_PATH = 'server/client_build/development'
PORT = process.env.PORT ? 3000
MONGO_URL = process.env.MONGO_URL ? "mongodb://localhost/peerioapi"
SESSION_SECRET = process.env.SESSION_SECRET ? 'keyboard kitty'
WHITELISTED_URLS = ['/login', '/signup', '/favicon.ico']

# connect MongoDB
mongoose.connect MONGO_URL

# controllers
publicController = require './server/controllers/public_controller'

  
app = express()

# livereload(app, config={})

# removing for 3.0 to 4.0 migration
# app.configure ->

# jade templates from templates dir
app.use compression()
app.set 'views', "#{__dirname}/server/templates"
app.set 'view engine', 'jade'

# serve static assets
app.use('/assets', express.static("#{__dirname}/#{ASSET_BUILD_PATH}"))


# logging
# 3.0 to 4.0 migration changing logger to morgan
app.use morgan()
  
# public routes
app.get '/', publicController.index
app.get '/about', publicController.about

 
module.exports = app
