/**
 * @type { import("/Applications/Finicky.app/Contents/Resources/finicky.d.ts").FinickyConfig }
 */

// Configure for https://github.com/johnste/finicky
// Documentation:
//  - https://github.com/johnste/finicky?tab=readme-ov-file#documentation
//  - https://github.com/johnste/finicky/wiki/Configuration-(v4)


export default {
  defaultBrowser: "Google Chrome",

  rewrite: [
    {
      // Rewrite URLs to hammerspoon protocol when not from Hammerspoon
      match: ({ options }) => options?.opener?.name !== "Hammerspoon",
      url: (url) => `hammerspoon://openInChrome?url=${encodeURIComponent(url.href)}`,
    },
  ],
};
