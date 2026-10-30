"""Standard standalone scientific SVG from already validated complete records."""
def limits(records):
    import math
    return {metric:math.ceil(max(r['speedup']for r in records if int(r['keys'])==1<<25 and r['target_metric']==metric))*1.04
      for metric in ('parallel_allocate_insert','parallel_lookup')}

def plot_large(records,path,preview=None):
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    from matplotlib.ticker import MaxNLocator
    matplotlib.rcParams.update({'svg.hashsalt':'native-range-scaling60','font.size':10,'svg.fonttype':'none'})
    geometry=[('Split64',16),('Split64',32),('Split64Range',16),('Split64Range',24),('Split64Range',32)]
    colors=['#2166ac','#67a9cf','#1b7837','#7fbc41','#d95f02']
    fig,axes=plt.subplots(2,2,figsize=(10.5,7),sharex=True,sharey='col')
    for i,language in enumerate(('cpp','rust')):
        for j,(metric,label)in enumerate((('parallel_allocate_insert','Allocate + whole build'),('parallel_lookup','Whole-array query'))):
            ax=axes[i,j]
            for (family,cap),color in zip(geometry,colors):
                values=sorted((r for r in records if r['language']==language and r['filter']==family and int(r['requested_bpk'])==cap and int(r['keys'])==1<<25 and r['target_metric']==metric),key=lambda r:r['core_budget'])
                if [r['core_budget']for r in values]!=[1,4,8]:raise ValueError('Missing exact large-input curve')
                ax.plot([r['core_budget']for r in values],[r['speedup']for r in values],marker='o',linewidth=1.8,color=color,
                  linestyle='--'if family=='Split64'else'-',label=f"{'Split64'if family=='Split64'else'Range'} {cap} bpk")
            ax.axhline(1,color='#777777',linewidth=.8,zorder=0);ax.grid(axis='y',alpha=.25)
            ax.set_title(f"{'C++'if language=='cpp'else'Rust'} · {label}")
            ax.set_xticks([1,4,8]);ax.yaxis.set_major_locator(MaxNLocator(integer=True))
            if i==1:ax.set_xlabel('Allowed physical cores (T)')
            if j==0:ax.set_ylabel('Same-row serial / parallel')
    bounds=limits(records)
    for j,metric in enumerate(('parallel_allocate_insert','parallel_lookup')):
        for i in range(2):axes[i,j].set_ylim(0,bounds[metric])
    handles,labels=axes[0,0].get_legend_handles_labels()
    fig.legend(handles,labels,loc='lower center',ncol=5,frameon=False,bbox_to_anchor=(.5,.025))
    fig.suptitle('Native public-API scaling · 33,554,432 keys · seed 42')
    fig.text(.5,.005,'Separate within-language controls; full native thread and partition costs included.',ha='center',fontsize=9)
    fig.tight_layout(rect=(0,.08,1,.95));fig.savefig(path,format='svg',metadata={'Date':None})
    if preview is not None:fig.savefig(preview,format='png',dpi=120)
    plt.close(fig)
