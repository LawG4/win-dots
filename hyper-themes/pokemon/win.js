// Old hyper config
// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  plugins: ["hyper-pokemon",
  "hypercwd"],
  config: {

    pokemon: 'random',
    unibody: 'true',

    updateChannel: 'stable',
    fontSize: 14,
    fontFamily: 'Hack, "Roboto Mono", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
    fontWeight: 'heavy',
    fontWeightBold: 'bold',
    lineHeight: 1,
    letterSpacing: 0,
    cursorColor: 'rgba(248,28,229,0.8)',
    cursorAccentColor: '#000',
    cursorShape: 'BEAM',
    cursorBlink: true,
    foregroundColor: '#fff',
    backgroundColor: '#000',
    selectionColor: 'rgba(248,28,229,0.3)',  
    borderColor: '#333',
    padding: '12px 14px',

    colors: {
    },
    
    localPlugins: [],
    bell: false,
    copyOnSelect: false,
    defaultSSHApp: true,
    quickEdit: false,
    macOptionSelectionMode: 'vertical',
    webGLRenderer: true,

    //
    // Launch the shell as Msys2
    //
    shell: 'C:\\msys64\\usr\\bin\\bash.exe',
    shellArgs: ['--login', '-i'],
    env: {
        'CHERE_INVOKIN': '1',
        'MSYS2_PATH_TYPE': 'inherit'
    },
  },
};
