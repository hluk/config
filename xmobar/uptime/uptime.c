/*#include <stdio.h>*/
/*#include <linux/unistd.h>   */
#include <linux/kernel.h>   
/*#include <time.h>*/
/*#include <utmp.h>*/

#define ONEHOUR  3600
#define ONEMINUTE  60
#define LOADS_SCALE 65536.0

/*int getTime(void) {*/
	/*struct tm *t;*/
	/*time_t the_time;*/

	/*(void) time(&the_time);*/
	/*t = localtime(&the_time);*/

	/*printf("%02d/%02d %02d:%02d:%02d", t->tm_mday, t->tm_mon, t->tm_hour, t->tm_min, t->tm_sec);*/
	/*return(0);*/
/*}*/
int getUptime(void) {
	char *lcolor = "aquamarine3";
	char *ncolor = "#f0e050";
	char *hcolor = "#ff9a50";
	char *hhcolor = "#ff4000";

	struct sysinfo s_info;
	sysinfo(&s_info);

	int hours; int minutes;
	long int upminh;
	long int uptimes;

	uptimes = s_info.uptime;
	hours = uptimes / ONEHOUR;
	upminh = uptimes - hours * ONEHOUR;
	minutes = upminh / ONEMINUTE;

	float av[3];
	av[0] = s_info.loads[0] / LOADS_SCALE;
	av[1] = s_info.loads[1] / LOADS_SCALE;
	av[2] = s_info.loads[2] / LOADS_SCALE;

	char *upcolor;
	if (hours >= 2)
		upcolor = hhcolor;
	else if (hours == 1 && minutes > 30)
		upcolor = ncolor;
	else
		upcolor = lcolor;

	char *colors[3];
	for(int i = 0; i<3; ++i){
		if ( av[i] > 1.8 )
			colors[i] = hcolor;
		else if ( av[i] > 1.0 )
			colors[i] = ncolor;
		else
			colors[i] = lcolor;
	}


	printf("up <fc=%s>%i:%02i</fc>   load <fc=%s>%2.2f</fc> <fc=%s>%2.2f</fc> <fc=%s>%2.2f</fc>",
			upcolor, hours, minutes, colors[0], av[0], colors[1], av[1], colors[2], av[2]);
	return(0);
}

int main()
{
	getUptime();
	/*getTime();*/
	return(0);
}

