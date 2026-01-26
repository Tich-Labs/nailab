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
        'nailab-purple': '#913F98',
        'nailab-teal': '#50C6D8',
        'nailab-yellow': '#fbbf24'
      }
    },
  },
  plugins: [
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/aspect-ratio'),
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      {
        nailab_founder: {
          primary: "#9B4D96",
          secondary: "#35C9C9",
          accent: "#F472B6",
          neutral: "#1F2937",
          "base-100": "#ffffff",
          "base-200": "#f3f4f6",
          "base-300": "#e5e7eb",
          "base-content": "#111827",
          info: "#38BDF8",
          success: "#22C55E",
          warning: "#F59E0B",
          error: "#EF4444",
        },
      },
      "light",
      "dark",
    ],
    logs: false,
  },
}
