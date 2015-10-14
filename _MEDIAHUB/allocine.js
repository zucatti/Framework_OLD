if (scrapper=="ALLOCINE") {
					r=r.result.movie;
					_p.store_movies=r;
					//update genres
					var genres=[];
					for (var i=0;i<r.genre.length;i++) {
						genres.push({
							scrapper: scrapper,
							scrapper_id: r.genre[i].code,
							genre: r.genre[i].$
						});
					};
					// update certificates
					if (r.movieCertificate) {
						var certs={
							scrapper: scrapper,
							scrapper_id: r.movieCertificate.certificate.code,
							certificate: r.movieCertificate.certificate.$
						};
					} else {
						var certs={};
					};
					// update nationality
					var nationality=[];
					if (r.nationality) {
						for (var i=0;i<r.nationality.length;i++) {
							nationality.push({
								scrapper: scrapper,
								scrapper_id: r.nationality[i].code,
								nationality: r.nationality[i].$
							});
						};
					};
					// update casting
					var cast_properties=[];
					var casting=[];
					for (var i=0;i<r.castMember.length;i++) {
						cast_properties.push({
							scrapper: scrapper,
							scrapper_id: r.castMember[i].activity.code,
							crew: r.castMember[i].activity.$
						});
						casting.push({
							scrapper: scrapper,
							scrapper_id: r.castMember[i].person.code,
							person: r.castMember[i].person.name
						});
					};
					
					
					var langs=[];
					for (var i=0;i<r.language.length;i++) {
						langs.push({
							scrapper: scrapper,
							scrapper_id: r.language[i].code,
							lang: r.language[i].$
						});
					};
					var tags=[];
					for (var i=0;i<r.tag.length;i++) {
						tags.push({
							scrapper: scrapper,
							scrapper_id: r.tag[i].code,
							tag: r.tag[i].$
						});
					};
				
					/*

					Mise à jour de la base

					*/
					// Mise à jour des genres
					App.DB.post('library://genre',genres,function(response) {
						// Mise à jour des certificates
						App.DB.post('library://certificates',certs,function(response) {
							// Mise à jour des nationality
							App.DB.post('library://nationality',nationality,function(response) {
								// Mise à jour du crew
								App.DB.post('library://crew',cast_properties,function(response) {
									// Mise à jour du casting
									App.DB.post('library://casting',casting,function(response) {
										//Mise à jour langs
										App.DB.post('library://langs',langs,function(response) {
											// Mise à jour tags
											App.DB.post('library://tags',tags,function(response) {
											
												var genres=[];
												for (var i=0;i<r.genre.length;i++) {
													genres.push(parseInt(r.genre[i].code));
												};
												var nationality=[];
												for (var i=0;i<r.nationality.length;i++) {
													nationality.push(parseInt(r.nationality[i].code));
												};
												App.DB.get('mediahub://contents{length}?id='+itemID,function(response) {
													App.get('movieproperties textfield#TRuntime').setValue(_p.toSeconds(response.data[0].length));
												});
												var langs=[];
												for (var i=0;i<r.language.length;i++) {
													langs.push(parseInt(r.language[i].code));
												};											
												App.get('movieproperties boxselect#TLanguage').setValue(langs);
												var tags=[];
												for (var i=0;i<r.tag.length;i++) {
													tags.push(r.tag[i].code);
												};
												App.get('movieproperties boxselect#TTags').setValue(tags);												
												App.get('movieproperties boxselect#TGenre').setValue(genres);	
												App.get('movieproperties boxselect#TPays').setValue(nationality);
												App.get('movieproperties textfield#TTitle').setValue(r.title);
												App.get('movieproperties textfield#TOriginalTitle').setValue(r.originalTitle);
												App.get('movieproperties textarea#TSynopsis').setValue(strip(r.synopsisShort));
												App.get('movieproperties htmleditor#TText').setValue(r.synopsis);
												App.get('movieproperties textfield#TActors').setValue(r.castingShort.actors);
												
												if (r.movieCertificate)	{
													App.get('movieproperties combo#TComboCertificate').getStore().load();
													App.get('movieproperties combo#TComboCertificate').setValue(parseInt(r.movieCertificate.certificate.code));
												};
												if (r.release) App.get('movieproperties datefield#TReleaseYear').setValue(r.release.releaseDate);
												App.get('movieproperties textfield#TBudget').setValue(r.budget);
												if (r.trailerEmbed) {
													var trailer=r.trailerEmbed.split("<iframe src='")[1].split("'")[0];
													App.get('movieproperties panel#TTrailer').update('<iframe style="width:100%;height:420px" src="'+trailer+'"></iframe>');
												};
												$('.TPosterMovie').css('background-image','url('+r.poster.href+')');
												var data=[];
												for (var i=0;i<_p.store_movies.castMember.length;i++) {
													var z={
														movie_id: itemID,
														cast_id: _p.store_movies.castMember[i].person.code,
														cast: _p.store_movies.castMember[i].person.name,
														crew_id: _p.store_movies.castMember[i].activity.code,
														crew: _p.store_movies.castMember[i].activity.$				
													};
													if (_p.store_movies.castMember[i].role) {
														z.role=_p.store_movies.castMember[i].role;
													};
													data.push(z);
												};
												App.get('grid#Cast').getStore().loadData(data);
												App.get('grid#Cast').getView().refresh();
												var html=[];
												for (var i=0;i<r.media.length;i++)
												{
													html.push({
														poster: r.media[i].thumbnail.href,
														title: r.media[i].title
													});
												};
												App.get('movieproperties dataview#MoviePhotos').getStore().loadData(html);
											});
										});
									});
								});
							});
						});
					});				
				}
			