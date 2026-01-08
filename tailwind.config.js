/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        'nailab-purple': '#5b21b6',
        'nailab-teal': '#14b8a6',
        'nailab-yellow': '#fbbf24'
      }
    },
  },
  plugins: [],
}