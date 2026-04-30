sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/mt/lotr/ui/test/integration/pages/CharactersList",
	"com/mt/lotr/ui/test/integration/pages/CharactersObjectPage",
	"com/mt/lotr/ui/test/integration/pages/WeaponsObjectPage"
], function (JourneyRunner, CharactersList, CharactersObjectPage, WeaponsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/mt/lotr/ui') + '/test/flp.html#app-preview',
        pages: {
			onTheCharactersList: CharactersList,
			onTheCharactersObjectPage: CharactersObjectPage,
			onTheWeaponsObjectPage: WeaponsObjectPage
        },
        async: true
    });

    return runner;
});

