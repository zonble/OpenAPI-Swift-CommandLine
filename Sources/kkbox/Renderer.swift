import KKBOXOpenAPISwift
import Foundation

internal class Renderer {
	enum OutputType {
		case error
		case standard
	}

	static func write(message: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\(message)")
		case .error:
			fputs("\u{001B}[0;31mError:\u{001B}[;m \(message)\n", stderr)
		}
	}

	static func render(error: Error) {
		self.write(message: error.localizedDescription, to: .error)
	}

	static func render(paging: KKPagingInfo) {
		let message = "------------------------------------------------------------\n" +
				"offset:\(paging.offset) limit:\(paging.limit) previous:\(String(describing: paging.previous)) next:\(String(describing: paging.next))"
		self.write(message: message)
	}

	static func render(summary: KKSummary) {
		let message = "total: \(summary.total)"
		self.write(message: message)
	}

	static func render(playlistList: KKPlaylistList) {
		for playlist in playlistList.playlists {
			self.render(playlist: playlist)
			self.write(message: "")
		}
		self.render(paging: playlistList.paging)
		self.render(summary: playlistList.summary)
	}

	static func render(track: KKTrackInfo) {
		let message = """
Track ID	\(track.ID)
Track Name	\(track.name)
URL		\(track.url?.absoluteString ?? "N/A")
Durtation	\(track.duration)
Album ID	\(track.album?.ID ?? "N/A")
Album Name	\(track.album?.name ?? "N/A")
Album URL	\(track.album?.url?.absoluteString ?? "N/A")
Album Images	\(String(describing: track.album?.images))
Artist ID	\(track.album?.artist?.ID ?? "N/A")
Artist Name	\(track.album?.artist?.name ?? "N/A")
Artist URL	\(track.album?.artist?.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: track.album?.artist?.images))
Order Index	\(track.trackOrderInAlbum)
"""
		self.write(message: message)
	}

	static func render(tracks: KKTrackList) {
		for track in tracks.tracks {
			self.render(track: track)
			self.write(message: "")
		}
		self.render(paging: tracks.paging)
		self.render(summary: tracks.summary)
	}

	static func render(album: KKAlbumInfo) {
		let message = """
Album ID	\(album.ID)
Album Name	\(album.name)
Album URL	\(album.url?.absoluteString ?? "N/A")
Album Images	\(album.images)
Released At	\(album.releaseDate ?? "N/A ")
Artist ID	\(album.artist?.ID ?? "N/A")
Artist Name	\(album.artist?.name ?? "N/A")
Artist URL	\(album.artist?.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: album.artist?.images))
"""
		self.write(message: message)
	}

	static func render(albums: KKAlbumList) {
		for album in albums.albums {
			self.render(album: album)
			self.write(message: "")
		}
		self.render(paging: albums.paging)
		self.render(summary: albums.summary)
	}

	static func render(artist: KKArtistInfo) {
		let message = """
Artist ID	\(artist.ID)
Artist Name	\(artist.name)
Artist URL	\(artist.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: artist.images))
"""
		self.write(message: message)
	}

	static func render(artists: KKArtistList) {
		for artist in artists.artists {
			self.render(artist: artist)
			self.write(message: "")
		}
		self.render(paging: artists.paging)
		self.render(summary: artists.summary)
	}

	static func render(playlist: KKPlaylistInfo) {
		let message = """
Playlist ID	\(playlist.ID)
Playlist Name	\(playlist.title)
Playlist URL	\(playlist.url?.absoluteString ?? "N/A")
Playlist Images	\(String(describing: playlist.images))
Updated at	\(playlist.lastUpdateDate)
Curator		\(playlist.owner.ID) \(playlist.owner.name)
"""
		self.write(message: message)
	}

	static func render(featuredPlaylistCategories :KKFeaturedPlaylistCategoryList) {
		for category in featuredPlaylistCategories.categories {
			let message = "\(category.ID) \(category.title)"
			self.write(message: message)
		}
		self.render(paging: featuredPlaylistCategories.paging)
		self.render(summary: featuredPlaylistCategories.summary)
	}

	static func render(featuredPlaylistCategory :KKFeaturedPlaylistCategory) {
		self.write(message: featuredPlaylistCategory.ID)
		self.write(message: featuredPlaylistCategory.title)
		self.write(message: "\(featuredPlaylistCategory.images)")

		guard let playlists = featuredPlaylistCategory.playlists else {
			return
		}
		for playlist in playlists.playlists {
			self.render(playlist: playlist)
			self.write(message: "")
		}
		self.render(paging: playlists.paging)
		self.render(summary: playlists.summary)
	}

	static func render(stations: KKRadioStationList) {
		for station in stations.stations {
			let message = """
Station ID	\(station.ID)
Station Name	\(station.name)
Station Images	\(String(describing: station.images))
"""
			self.write(message: message)
			self.write(message: "")
		}
		self.render(paging: stations.paging)
		self.render(summary: stations.summary)
	}

	static func render(station: KKRadioStation) {
		let message = """
Station ID	\(station.ID)
Station Name	\(station.name)
Station Images	\(String(describing: station.images))
"""
		self.write(message: message)
		guard let tracks = station.tracks else {
			return
		}
		for track in tracks.tracks {
			self.render(track: track)
			self.write(message: "")
		}
		self.render(paging: tracks.paging)
		self.render(summary: tracks.summary)
	}

	static func render(newReleaseAlbumsCategories: KKNewReleasedAlbumsCategoryList) {
		for category in newReleaseAlbumsCategories.categories {
			let message = "\(category.ID) \(category.title)"
			self.write(message: message)
		}
		self.render(paging: newReleaseAlbumsCategories.paging)
		self.render(summary: newReleaseAlbumsCategories.summary)
	}

	static func render(newReleaseAlbumsCategory category: KKNewReleasedAlbumsCategory) {
		let message = """
Category ID		\(category.ID)
Category Title	\(category.title)
"""
		self.write(message: message)
		guard let albums = category.albums else {
			return
		}
		for album in albums.albums {
			self.render(album: album)
			self.write(message: "")
		}
		self.render(paging: albums.paging)
		self.render(summary: albums.summary)
	}

	static func renderHelp() {
		let help = """
Usage:

    $ kkbox COMMAND

    A commandline tool to access KKBOX's Open API.

Commands:

    set_client_id (ID) (SECRET)         Set client ID and secret.
    get_client_id (ID) (SECRET)         Get client ID and secret.
    featured_playlists                  Fetch features playlists.
    featured_playlists_categories       Fetch features playlist categories.
    featured_playlists_category (ID)    Fetch playlists in a category.
    new_hits_playlists                  Fetch new hits playlists.
    charts                              Fetch charts.
    track (TRACK_ID)                    Fetch a track.
    album (ALBUM_ID)                    Fetch an album.
    artist (ARTIST_ID)                  Fetch an artist.
    artist_albums (ARTIST_ID)           Fetch albums of an artist.
    playlist (PLAYLSIT_ID)              Fetch a playlist.
    mood_stations                       Fetch mood stations.
    mood_station (STATION_ID)           Fetch a mood station.
    genre_stations                      Fetch genre stations.
    grene_station (STATION_ID)          Fetch a genre station.
    new_release_categories              Fetch new released album categories.
    new_release_category (ID)           Fetch albums in a new released album category
    search_track (KEYWORD)              Search for tracks.
    search_album (KEYWORD)              Search for albums.
    search_artist (KEYWORD)             Search for artists.
    search_playlist (KEYWORD)           Search for playlists.
    version                             Print version of the tool.
    help                                This help.
"""
		write(message: help)
	}
}
