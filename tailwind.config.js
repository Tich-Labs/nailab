/** @type {import('tailwindcss').Config} */
const colors = require('tailwindcss/colors');

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/views/**/*.erb',
    './app/helpers/**/*.rb'
  ],
  theme: {
    extend: {
      colors: {
        gray: colors.gray,
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        accent: '#00BCD4',
        primary: {
          DEFAULT: 'rgb(150, 55, 140)',
          dark: '#4A148C',
        },
      },
    },
  },
  plugins: [],
}