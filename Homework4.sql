-- 5.A
SELECT 
    ROUND(AVG(EXTRACT(epoch FROM Duration) / 60)) AS AverageDurationInMinutes
FROM 
    Songs
WHERE 
    EXTRACT(epoch FROM Duration) BETWEEN 5 * 60 AND 25 * 60;

-- 5.B
SELECT 
    ROUND(SUM(EXTRACT(epoch FROM Duration) / 60)) AS TotalDurationInMinutes
FROM 
    Songs
WHERE 
    IsExplicit = 1;

-- 5.C
SELECT 
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT EXTRACT(year FROM ReleaseDate))) AS AvgSongsPerYear
FROM 
    Songs;

-- 5.D
SELECT 
    ROUND(MAX(AverageDuration)) AS MaxAverageDuration
FROM (
    SELECT 
        a.AlbumId,
        AVG(EXTRACT(epoch FROM s.Duration)) AS AverageDuration
    FROM 
        Albums a
    JOIN AlbumArtists aa ON a.AlbumId = aa.AlbumId
    JOIN Artists ar ON aa.ArtistId = ar.ArtistId
    JOIN AlbumSongs als ON a.AlbumId = als.AlbumId
    JOIN Songs s ON als.SongId = s.SongId
    WHERE 
        ar.Artist = 'Miles Davis'
    GROUP BY 
        a.AlbumId
) AlbumDurations;

-- 5.E
SELECT 
    SUM(CountOfSongs) AS TotalSongs
FROM (
    SELECT 
        Title, 
        COUNT(*) AS CountOfSongs
    FROM 
        Songs
    GROUP BY 
        Title
    HAVING 
        COUNT(*) >= 4
) SongsWithRepeatedTitles;

-- 5.F
SELECT 
    COUNT(DISTINCT s.SongId) AS TotalSongs
FROM 
    Songs s
LEFT JOIN 
    AlbumSongs als ON s.SongId = als.SongId
LEFT JOIN 
    Albums a ON als.AlbumId = a.AlbumId
WHERE 
    s.ReleaseDate > '2010-12-31'
    OR EXTRACT(MONTH FROM a.AlbumReleaseDate) = 1;

-- 5.G
SELECT 
    COUNT(DISTINCT a.AlbumId) AS TotalAlbums
FROM 
    Albums a
JOIN 
    AlbumSongs als ON a.AlbumId = als.AlbumId
JOIN 
    Songs s ON als.SongId = s.SongId
GROUP BY 
    a.AlbumId
HAVING 
    COUNT(s.SongId) > 1
    AND SUM(CASE WHEN s.IsExplicit = 0 THEN 1 ELSE 0 END) = 0;

-- 5.H
WITH AlbumGenreCounts AS (
    SELECT 
        a.AlbumId,
        a.Album AS AlbumName,
        COUNT(DISTINCT ag.GenreId) AS GenreCount
    FROM 
        Albums a
    JOIN 
        AlbumGenres ag ON a.AlbumId = ag.AlbumId
    GROUP BY 
        a.AlbumId, a.Album
),
MaxGenreCount AS (
    SELECT 
        MAX(GenreCount) AS MaxGenres
    FROM 
        AlbumGenreCounts
)
SELECT 
    AlbumName,
    GenreCount
FROM 
    AlbumGenreCounts
WHERE 
    GenreCount = (SELECT MaxGenres FROM MaxGenreCount);
