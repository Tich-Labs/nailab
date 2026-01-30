/** @type {import('tailwindcss').Config} */
module.exports = {
  future: {
    applyComplexClasses: true,
  },
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
          primary: "#14b8a6", // teal-500
          'primary-content': '#ffffff',
          secondary: "#35C9C9",
          accent: "#2dd4bf", // teal-400
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
  safelist: [
    'bg-nailab-purple',
    '!bg-nailab-purple',
    'bg-nailab-purple/10',
    'from-nailab-purple',
    'text-nailab-purple',
    'border-nailab-purple',
    'focus:ring-nailab-purple',
    'hover:!bg-nailab-purple'
  ],
}
