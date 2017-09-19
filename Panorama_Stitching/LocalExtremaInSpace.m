function LocExtSp = LocalExtremaInSpace(m)

    m_l = circshift(m, [0 -1]);
    m_r = circshift(m, [0 1]);
    m_u = circshift(m, [-1 0]);
    m_d = circshift(m, [1 0]);
    m_lu = circshift(m, [-1 -1]);
    m_ru = circshift(m, [-1 1]);
    m_ld = circshift(m, [1 -1]);
    m_rd = circshift(m, [1 1]);
    
    LocExtSp = ((m > m_l) & (m > m_r) & (m > m_u) & (m > m_d) & (m > m_lu) & (m > m_ru) & (m > m_ld) & (m > m_rd)) | ((m < m_l) & (m < m_r) & (m < m_u) & (m < m_d) & (m < m_lu) & (m < m_ru) & (m < m_ld) & (m < m_rd));

end