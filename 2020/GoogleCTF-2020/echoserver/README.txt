FD_set OOB overflow, send 64 connections at once to leak
Then rop to dup2 and system
Since remote system has 4 cores, this harms reliability, so we use a common exploitation trick of making NUM_CPU dummy spinner threads to clog up the other cores so that all our stuff """gets scheduled more reliably""" (quotes because we are actually just lying and deluding ourselves with made up stories about the scheduler)
See exp.c for exploit