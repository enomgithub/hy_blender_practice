#!/usr/bin/env hy
;; -*- coding: utf-8 -*-

(import math)
(import random)
(import sys)

(import bpy)


(defn main []
  (setv start 0)
  (setv end 100)
  (setv n 10)
  (setv radius 5)
  (setv alpha 0.6)
  (setv frame-step 10)

  ((. random seed))

  (setv (. bpy context scene frame-start) start)
  (setv (. bpy context scene frame-end) end)

  (for [x (range n)]
       (for [y (range n)]
            (for [z (range n)]
                 ((. bpy ops mesh primitive-cube-add)
                  :radius radius)
                 (setv obj (. bpy context scene objects active))
                 (setv mat ((. bpy data materials new) "Cube"))
                 (setv (. mat diffuse-color)
                       (, (/ x n)
                          (/ y n)
                          (/ z n)))
                 (setv (. mat use-transparency) True)
                 (setv (. mat alpha) alpha)
                 ((. obj data materials append) mat)

                 ;; set each key frames
                 (setv span (- end start))
                 (for [frame
                       (range start
                              (+ end frame-step)
                              frame-step)]
                      ((. bpy context scene frame-set) frame)
                      (setv (. obj location)
                            (, (-> x
                                   (+ ((. random randrange)
                                       (- radius)
                                       radius))
                                   (* 2 radius))
                               (-> y
                                   (+ ((. random randrange)
                                       (- radius)
                                       radius))
                                   (* 2 radius))
                               (-> z
                                   (+ ((. random randrange)
                                       (- radius)
                                       radius))
                                   (* 2 radius))))
                      ((. obj keyframe-insert)
                       :data-path "location")))))
  0)


(when (= --name-- "__main__")
      ((. sys exit) (main)))
