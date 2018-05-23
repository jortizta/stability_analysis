params;

loadoperatorsandmesh;

switch analysistype
case 'spectrumdirect'
    compspectrumdirect;
case 'spectrumadjoint'
    compspectrumadjoint;
case 'pseudospectrum'
    comppseudospectrum;
case 'freqresp'
    compfreqresp;
case 'freqrespthroughpseudospectrum'
    compfreqrespthroughpseudospectrum;
case 'misc'
    compmisc;
end

