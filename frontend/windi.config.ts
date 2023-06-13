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
      // Theme Color
      red: "#BB0F17",
      orange: "#BE9505",
      yellow: "#E9B200",
      green: "#18A058",
      teal: "#008E8E",
      blue: "#3A80C0",
      indigo: "#6B23B4",
      purple: "#8A3FFC",
      pink: "#D63384",
    },
    extend: {
      // Border Color
      borderColor: {
        success: "#62AE01",
        warning: "#BE9505",
        danger: "#BB0F17",
        info: "#6B23B4",
        // Grayscale Color
        title: "#0C0C0D", // Gray-900
        body: "#444547", // Gray-700
        secondary: "#757A80", // Gray-500
        disabled: "#BABDBF", // Gray-300
        // Theme Color
        red: "#BB0F17",
        orange: "#BE9505",
        yellow: "#E9B200",
        green: "#62AE01",
        teal: "#008E8E",
        blue: "#3A80C0",
        indigo: "#6B23B4",
        purple: "#8A3FFC",
        pink: "#D63384",
      },
      fontFamily: {
        sans: '"Noto Sans TC", "Helvetica Neue", sans-serif',
        // mono: '"Fira Code", monospace',
      },
    },
  },
});
