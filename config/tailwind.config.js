/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/views/layouts/**/*.html.erb'
  ],
  theme: {
    extend: {
      colors: {
        nailab: {
          purple: 'rgb(150, 55, 140)',
          teal: 'rgb(80, 198, 216)',
          "purple-light": 'rgb(192, 14, 228)',
          "teal-light": 'rgba(100, 195, 215, 0.1)',
          yellow: 'rgb(235, 191, 56)',
          "yellow-light": 'rgb(245, 216, 131)',
          biege: 'rgb(244, 132, 131)',
          "purple-dark": 'rgb(26, 1, 41)',
          "purple-deep": 'rgb(63, 0, 80)',
        },
      },
      fontFamily: {
        gotham: ['Gotham', 'sans-serif'],
      },
      container: {
        center: true,
        padding: '2rem',
        screens: {
          '2xl': '1400px'
        }
      },
    },
  },
  plugins: [],
}
