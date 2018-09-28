cd /srv/arcadia
git pull

# load yaml data
node resume.js

# load views
node about.js
node skills.js
node projects.js
node industry_from.js
node education_from.js

# compile template
babel template.js --presets react > template-compiled.js
node server.js &
