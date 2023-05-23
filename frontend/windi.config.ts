import { defineConfig } from "windicss/helpers";

export default defineConfig({
  darkMode: "class",
  attributify: true,
  theme: {
    textColor: {
      success: "#62AE01",
      warning: "#BE9505",
      danger: "#BB0F17",
      info: "#6B23B4",
      // Grayscale Color
      title: "#0C0C0D", // Gray-900
      body: "#444547", // Gray-700
      secondary: "#757A80", // Gray-500
      disabled: "#BABDBF", // Gray-300
    },
    extend: {
      fontFamily: {
        sans: '"Noto Sans TC", "Helvetica Neue", sans-serif',
        // mono: '"Fira Code", monospace',
      },
    },
  },
});
