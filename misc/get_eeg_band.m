function f = get_eeg_band(band)
switch band
    case 'delta'
        f = [0.5, 4];
    case 'theta'
        f = [4, 8];
    case 'alpha'
        f = [8, 13];
    case 'mu'
        f = [8, 12];
    case 'mu-low'
        f = [8, 10];
    case 'mu-high'
        f = [10, 13];        
    case 'beta1'
        f = [12, 15];
    case 'beta2'
        f = [15, 19];
    case 'beta3'
        f = [22, 38];
    case 'beta-motor'
        f = [16, 24];
    case 'delta-to-beta1'
        f = [0.5, 15];      
    case 'none'
        f = [0, Inf];
    otherwise
        error('Bad band specified')
end
end