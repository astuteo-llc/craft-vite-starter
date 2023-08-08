// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')
module.exports = {
  content: [
    './templates/**/*.{twig,html}',
    './src/js/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {

      },
      boxShadow: {
      },
      colors: {
      }
    },
  },
}
