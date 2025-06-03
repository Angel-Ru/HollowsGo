import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  standalone: true,
  imports: [RouterModule],
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  private audio!: HTMLAudioElement;
  isMuted: boolean = false;

  constructor(private cd: ChangeDetectorRef) {}

  ngOnInit(): void {
    // Crear l'objecte de l'àudio amb autoplay i loop
    this.audio = new Audio('https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/MUSICA/ysqv9ww78jmpwijmb7qg');
    this.audio.loop = true;
    this.audio.autoplay = true;
    this.audio.volume = 0.5; // Pots ajustar el volum inicial
    this.audio.muted = false; // Assegura't que el so estigui activat des del principi

    // Algunes plataformes poden requerir una interacció de l'usuari per iniciar l'àudio.
    // Però aquí forcem el play automàticament.
    this.audio.play().catch(err => console.warn('L\'àudio necessita interacció de l\'usuari a alguns navegadors:', err));
  }

  toggleMute(): void {
    this.isMuted = !this.isMuted;
    this.audio.muted = this.isMuted;
    this.cd.detectChanges();
  }

  ngOnDestroy(): void {
    if (this.audio) {
      this.audio.pause();
      this.audio.src = '';
    }
  }
}
