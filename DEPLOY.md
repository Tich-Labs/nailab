CSS build reminder
------------------

This project uses Tailwind CSS with the DaisyUI plugin. When deploying to production,
ensure the compiled CSS is built and available to the app asset pipeline.

Recommended step (run on the build host / CI before deploying):

```bash
npm ci --silent
npm run build:css
```

The `build:css` script will produce the compiled Tailwind output used by the
founder pages and other layouts. Without this step DaisyUI classes may not
be present in production and UI styling can appear broken.

If you use a CI provider, add the `npm run build:css` step to the build stage
before assets are packaged.
