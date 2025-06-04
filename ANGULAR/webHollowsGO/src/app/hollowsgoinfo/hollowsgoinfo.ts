import { Component, OnInit, OnDestroy } from '@angular/core';
import { NgForOf } from '@angular/common';

@Component({
  selector: 'app-hollowsgoinfo',
  standalone: true,
  imports: [NgForOf],
  templateUrl: './hollowsgoinfo.html',
  styleUrl: './hollowsgoinfo.css'
})
export class Hollowsgoinfo implements OnInit, OnDestroy {
  images: string[] = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/u3rayqj3ozb0tmkucf0p',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/azevfdojdy9gwtwsvjpg',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/i22hxtu0hrlqpvwnpvus'
  ];

  tenda: string[] = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/gz60njhmwp3ultysdic5',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/s2cuqbfigljiu45ajpl5',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/vtpb8pbzq9twlhu7t0t9'
  ]
  index: number = 0;

  isPlaying: boolean = false;
  isMuted: boolean = false;
  progress: number = 0;

  ngOnInit(): void {
    this.updateBackground();
    window.addEventListener('resize', this.updateBackground.bind(this));
  }

  ngOnDestroy(): void {
    document.body.style.backgroundImage = '';
    document.body.style.backgroundColor = '';
    window.removeEventListener('resize', this.updateBackground);
  }

  prevSlide(): void {
    this.index = (this.index - 1 + this.images.length) % this.images.length;
  }

  nextSlide(): void {
    this.index = (this.index + 1) % this.images.length;
  }

  getTransform(): string {
    return `translateX(-${this.index * 100}%)`;
  }

  togglePlay(video: HTMLVideoElement): void {
    if (video.paused) {
      video.play();
      this.isPlaying = true;
    } else {
      video.pause();
      this.isPlaying = false;
    }
  }

  toggleMute(video: HTMLVideoElement): void {
    video.muted = !video.muted;
    this.isMuted = video.muted;
  }

  updateProgress(video: HTMLVideoElement): void {
    if (video.duration) {
      this.progress = (video.currentTime / video.duration) * 100;
    } else {
      this.progress = 0;
    }
  }

  // Nou: permet fer "seek" clicant a la barra
  seekVideo(event: MouseEvent, video: HTMLVideoElement): void {
    const target = event.currentTarget;

    if (!(target instanceof HTMLElement)) {
      return; // Si no és HTMLElement, sortim (seguretat)
    }

    const rect = target.getBoundingClientRect();
    const clickX = event.clientX - rect.left;
    const width = rect.width;
    const clickRatio = clickX / width;

    if (video.duration) {
      video.currentTime = video.duration * clickRatio;
    }
  }



  private updateBackground(): void {
    const isLandscape = window.matchMedia('(orientation: landscape)').matches;
    const imageUrl = isLandscape
      ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/kdopgq4rlbanmrurspow'
      : 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/e3wettuzovqwdicdhpmg';

    document.body.style.backgroundImage = `url('${imageUrl}')`;
    document.body.style.backgroundSize = 'cover';
    document.body.style.backgroundRepeat = 'no-repeat';
    document.body.style.backgroundPosition = 'center';
    document.body.style.backgroundColor = '#1b0c04';
  }

  protected readonly HTMLElement = HTMLElement;
}
