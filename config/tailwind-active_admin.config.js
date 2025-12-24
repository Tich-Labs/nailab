module.exports = {
  content: [
    './app/assets/stylesheets/active_admin.css',
    './app/views/layouts/active_admin_custom.html.erb',
    './app/admin/**/*.rb'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#6A1B9A',
        'primary-dark': '#4A148C',
        accent: '#00BCD4',
        neutral: '#F5F5F5',
      },
    },
  },
  plugins: [],
}