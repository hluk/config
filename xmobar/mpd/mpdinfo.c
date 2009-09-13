#include <stdio.h>
#include <libmpd/libmpd.h>

int main(){
	MpdObj *mpd = mpd_new_default();
	if (! mpd || mpd_connect(mpd) != MPD_OK) return 0;

	mpd_Song *song = mpd_playlist_get_current_song(mpd);
	if (song) {

		char *artist = song->artist;
		char *title = song->title;
		int total = mpd_status_get_total_song_time(mpd);
		int elapsed = mpd_status_get_elapsed_song_time(mpd);
		int state = mpd_player_get_state(mpd);

		switch (state) {
			case MPD_PLAYER_PAUSE:
				printf("|| ");
				break;
			case MPD_PLAYER_PLAY:
				printf("» ");
				break;
			default:
				break;
		}

		printf("<fc=#80e0ff>");
		if (artist)
			printf("%s - ", artist);
		printf(title);
		printf("</fc>");

		printf("<fc=aquamarine3>");
		if (elapsed >= 0)
			printf(" %02d:%02d",elapsed/60,elapsed%60);
		if (total > 0)
			printf("/%02d:%02d",total/60,total%60);
		printf("</fc>");
	}
	
	mpd_disconnect(mpd);
	mpd_free(mpd);
	return 0;
}
