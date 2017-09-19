function LocExtSc = LocalExtremaInScale(m)
    
    m_f = circshift(m, [0 0 1]);
    m_b = circshift(m, [0 0 -1]);
    
    LocExtSc = [];
    n = ((m > m_f) & (m > m_b)) | ((m < m_f) & (m < m_f));
    LocExtSc = cat(3, LocExtSc, ones(size(m, 1), size(m, 2)), n(:, :, 2:size(m, 3)-1), ones(size(m, 1), size(m, 2)));
    
end