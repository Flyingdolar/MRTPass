module.exports = {
  pluginOptions: {
    electronBuilder: {
      builderOptions: {
        productName: 'MRT_pass',
        mac: {
          icon: 'public/icon.icns'
        },
        win: {
          icon: 'public/icon.ico'
        },
        linux: {
          icon: 'public/icon.png'
        }
      }
    }
  }
}